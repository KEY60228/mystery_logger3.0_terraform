# なぞログ (https://mystery-logger.com)

## 概要
謎解き、リアル脱出ゲーム<sup id="a1">[1](#f1)</sup>ユーザー用SNS

行った作品のレビューや行きたい作品のブックマークが出来るほか、気になる作品の評価を確認したり、行きたい作品の検索をすることが出来ます。

## 作ろうと思ったきっかけ
### 自分が「あったら嬉しい」と思ったから
謎解きやリアル脱出ゲーム<sup id="a2">[1](#f1)</sup>はその性質上ネタバレ厳禁とされ、オープンに感想共有や議論が出来る場がありませんでした。

そこで、

- 意図せずネタバレされるリスクなく
- 今まで交わることのなかったような人たちと
- オープンに議論ができ、
- 戦績や評価も可視化できる

そんなサービスがあったら嬉しいな、と考えたことが「なぞログ」を制作したきっかけの一つです。

### 新しい技術に触れてみたかったから

業務では15年来のサービスを担当しており、PHPとSQL以外の言語について触れることは稀でした。

また、今後サービス刷新、リプレイス等も予定されていないため、業務で新しい技術に触れられる機会はほぼない状態でした。

そこで、それならプライベートで新しい技術に触れ、プロダクトを作ってみれば良いのでは、と考えたこともきっかけの一つです。

## 使用技術

開発環境アーキテクチャ図
![開発環境アーキテクチャ図](https://images.mystery-logger.com/development_arch.PNG)

本番環境アーキテクチャ図
![本番環境アーキテクチャ図](https://images.mystery-logger.com/production_arch.PNG)

### バックエンド

- PHP 7.4 (Laravel 6.18)
- Go 1.16

### フロントエンド

- TypeScript 4.0.2 (React 16.13.1)

### インフラ

- Docker
- Circle CI
- Terraform 0.14.9
- Amazon Web Services
  - CloudFront, Route53
  - ACM, KMS, CloudWatch, IAM, CloudTrail, SSM, ECS, ECR, SMS, Lambda, SES
  - ELB, EC2, RDS, ElastiCache

### その他のツール

- Figma
- Swagger Editor
- Swagger Codegen
- Postman

Figmaデザイン1
![Figmaデザイン1](https://images.mystery-logger.com/Figma1.PNG)

Figmaデザイン2
![Figmaデザイン2](https://images.mystery-logger.com/Figma2.PNG)

## テストユーザー

ID: guest@guest.com

Pass: guestguest

---

<b id="f1">1</b>: 「リアル脱出ゲーム」は株式会社SCRUPの登録商標です。[↩](#a1)
