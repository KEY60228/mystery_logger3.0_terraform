FROM hashicorp/terraform:0.14.9

ENV AWS_ACCESS_KEY_ID="" AWS_SECRET_ACCESS_KEY="" AWS_DEFAULT_REGION=""

WORKDIR /terraform
RUN apk add --update --no-cache py3-pip \
    && pip3 install awscli --upgrade \
    && export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
    && export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
    && export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}