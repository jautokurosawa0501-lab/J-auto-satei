# 査定履歴機能のセットアップ手順

査定内容をネット上のデータベース(Supabase)に保存し、スマホ・PCどちらからでも
呼び出して印刷・PDF作成できるようにするための準備です。最初の1回だけ行います。

## 1. Supabaseのプロジェクトを作る

1. https://supabase.com にアクセスし、無料アカウントを作る(GitHubアカウントでも登録できる)
2. 「New project」でプロジェクトを作る
   - 名前: `j-auto-satei` など
   - Database Password: 自動生成でよい(このアプリでは使わないが、念のため控えておく)
   - Region: `Northeast Asia (Tokyo)`
   - プランは Free のまま

## 2. 表(テーブル)と鍵の設定を作る

1. 左メニューの「SQL Editor」を開く
2. このリポジトリの `supabase-setup.sql` の中身を全部貼り付けて「Run」
3. 「Success」と出ればOK

## 3. 知らない人が勝手に登録できないようにする(重要)

1. 左メニュー「Authentication」→ 設定画面(Sign In / Providers など)
2. 「Allow new users to sign up」(新規登録を許可)を **オフ** にして保存

これをオフにしないと、アプリの公開キーを知っている人が自分でアカウントを作れてしまいます。

## 4. お店の共通アカウントを作る

1. 「Authentication」→「Users」→「Add user」→「Create new user」
2. メールアドレスとパスワードを入れる
   - 「Auto Confirm User」(確認メールなしで有効にする)にチェック
3. このメールアドレスとパスワードで、査定システムにログインします

## 5. アプリに接続先を書き込む

1. 「Project Settings」→「API」(または「API Keys」)を開く
2. 次の2つをコピーする
   - Project URL(`https://xxxx.supabase.co` の形)
   - anon public キー(新しい画面では `sb_publishable_...` で始まる publishable キー)
3. `index.html` の下のほうにある次の2行に貼る

```js
var SUPABASE_URL = "ここにProject URL";
var SUPABASE_ANON_KEY = "ここにanonまたはpublishableキー";
```

**service_role キー / secret キーは絶対に貼らないこと。** 全データを自由に読み書きできる
管理者用の鍵で、公開されると誰でも履歴を見られるようになります。

## 使い方

- 💾 保存: 今の査定を保存(初回はログイン画面が出る)
- 📂 履歴を見る: 保存した査定の一覧。車名・登録No.などで検索できる
- 一覧から選ぶと画面に復元されるので、いつも通り「印刷」「PDFファイルを作成」
- 呼び出した査定を直して保存すると「上書き保存」か「新しい査定として保存」を選べる
- 「入力をリセット」で新しい査定に戻る

## 無料枠の目安

査定1件あたり数KB程度なので、無料枠(データベース500MB)で数万件以上入ります。
無料プランは、1週間まったく使われないとプロジェクトが一時停止されることがあります。
その場合はSupabaseの画面から「Restore」で再開できます(データは消えません)。
