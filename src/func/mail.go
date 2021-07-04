package main

import (
	"context"
	"fmt"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ses"
)

const (
	Sender = "info@mail.mystery-logger.com"
	Subject = "【なぞログ】仮登録が完了しました"
	Message = `なぞログに御登録頂きありがとうございます。

〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜

登録されたメールアドレス: %s

〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜

%sまでに下記のURLへアクセスして、メールアドレスの認証を行ってください。

https://mystery-logger.com/register?token=%s

(%sを経過してしまった場合は、お手数ですが再度メールアドレス登録画面から再入力をお願い致します。)

※本メールに心当たりがない場合は、どなたかが誤ってメールアドレスを入力した可能性がございます。本メールは破棄ください。
`
	CharSet = "UTF-8"
)

func handler(ctx context.Context, sqsEvent events.SQSEvent) error {
	for _, message := range sqsEvent.Records {
		var email, token, expiration_time string
		for k, v := range message.MessageAttributes {
			switch (k) {
			case "email":
				email = *v.StringValue
			case "token":
				token = *v.StringValue
			case "expiration_time":
				expiration_time = *v.StringValue
			}
		}
		body := fmt.Sprintf(Message, email, expiration_time, token, expiration_time)
		sendSES(body, email)
		fmt.Printf("The message %s for event source %s = %s\n", message.MessageId, message.EventSource, message.Body)
	}
	return nil
}

func sendSES(message string, email string) {
	sess, _ := session.NewSession(&aws.Config {
		Region: aws.String("ap-northeast-1")},
	)

	svc := ses.New(sess);

	input := &ses.SendEmailInput {
		Destination: &ses.Destination {
			CcAddresses: []*string{},
			ToAddresses: []*string{
				aws.String(email),
			},
		},
		Message: &ses.Message {
			Body: &ses.Body {
				Text: &ses.Content {
					Charset: aws.String(CharSet),
					Data: aws.String(message),
				},
			},
			Subject: &ses.Content {
				Charset: aws.String(CharSet),
				Data: aws.String(Subject),
			},
		},
		Source: aws.String(Sender),
	}

	result, err := svc.SendEmail(input)

	if err != nil {
		if aerr, ok := err.(awserr.Error); ok {
			switch aerr.Code() {
			case ses.ErrCodeMessageRejected:
				fmt.Println(ses.ErrCodeMessageRejected, aerr.Error())
			case ses.ErrCodeMailFromDomainNotVerifiedException:
				fmt.Println(ses.ErrCodeMailFromDomainNotVerifiedException, aerr.Error())
			case ses.ErrCodeConfigurationSetDoesNotExistException:
				fmt.Println(ses.ErrCodeConfigurationSetDoesNotExistException, aerr.Error())
			default:
				fmt.Println(aerr.Error())
			}
		} else {
			fmt.Println(err.Error());
		}

		return
	}
	fmt.Println(result)
}

func main() {
	lambda.Start(handler)
}
