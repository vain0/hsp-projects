# Routine Launcher
## 概要
任意の曜日・時刻にプログラムを実行するソフトウェアです。

## 設定
* link: 実行するリンク。exe ファイルのパスなど。
* mode: 実行モード
  * 0: 通常の実行
  * 2: 最小化モードで実行
  * 16: 関連付けられたプログラムで実行
* path: 実行するパス。ここをカレントディレクトリとして実行する。
* days: 実行する曜日
* time: 実行する時刻
  * ``hh:mm:ss`` の形式で書く。
  * 例: ``13:59:02`` (13時59分2秒)
* cnt: 実行する回数。
  * 実行するたびに1減る。
  * 0 なら実行しない。
  * -1 なら無制限。

## 更新履歴
#### 2012.02.12
* RoutineManager を一般化して、RecordWriter とした。

#### 2012.02.11
* データベースを初期化するプログラムを RoutineConfigInitializer として別ファイルにした。
* 終了時に、カラム幅を保存するようにした。

#### 2012.02.09
* ini ではなくデータベースを利用するようにした。
  * SQLele (SQLite)

#### 2012.02.08
* RoutineManager 1.0 完成。
  * ルーチンの編集・挿入処理、保存処理を実装。
  * リストビューの上から直接編集できるようにしたかったが、かなり難しげ。

#### 2012.02.07
* 補助ソフト RoutineManager の製作開始。
  * リストビューでの設定の表示、削除、上下移動処理のシミュレートなど。

#### ???
* パラメータ cnt を導入
* タスクトレイのメニューに、実行待機中のルーチンの情報を表示できるようにした
* 曜日制限を導入
* 初回版
