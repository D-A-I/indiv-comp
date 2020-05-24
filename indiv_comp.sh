#!/bin/bash
set -eu

# +++ 定数 +++

# 7zipの格納パス
ZIP7_PATH='C:\Program Files\7-Zip\7z.exe'
zip7=$(wslpath -u "${ZIP7_PATH}") # -u >> win -> unix

# +++ 変数 +++

# 引数1：対象のディレクトリ
fixed_dir=$(wslpath -u $1)
# 引数2：圧縮パスワード
pass=$2
# 退避先のディレクトリ
bk_dir=${fixed_dir}/xls

# +++ メイン処理 +++

echo "圧縮を開始します.. 対象 >> ${fixed_dir}"

# 元ファイルの退避先
[ ! -e ${bk_dir} ] && mkdir ${bk_dir}

# 対象のフォルダ配下をループ
zip_name=''
for file in $(find ${fixed_dir} -maxdepth 1 -type f); do
    # 7zipの引数用に、winのパスに戻す
    xls_name=$(wslpath -m ${file}) # -m >> unix -> win
    zip_name=${xls_name%.*}.zip

    # 7zip実行
    echo ".. ${xls_name}"
    "${zip7}" a -p${pass} ${zip_name} ${xls_name} > /dev/null

    # 元ファイル移動
    mv --force ${file} ${bk_dir} >> app.log
done

echo '圧縮が完了しました'
