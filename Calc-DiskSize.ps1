$dirPath = "./"  # カレントディレクトリを指定

$parentPath = (Get-Item -Path ".\").FullName  # 親ディレクトリのパスを取得

$sizeInfo = Get-ChildItem -Path $dirPath -Directory | ForEach-Object {
    # サブディレクトリのサイズを計算するための変数を初期化
    $subDirSize = 0
    # サブディレクトリのパスから親ディレクトリのパスを除いた結果を取得
    $subDirPath = $_.FullName.Replace($parentPath, "").TrimStart("\")
    # サブディレクトリ内のファイルを再帰的に取得し、サイズを計算
    Get-ChildItem $_.FullName -File -Recurse | ForEach-Object {
        $subDirSize += $_.Length / 1MB
    }
    # サイズを桁数4で丸める
    $subDirSize = [Math]::Round($subDirSize, 4, [System.MidpointRounding]::AwayFromZero)
    # サブディレクトリのパスとそのサイズをカスタムオブジェクトに格納
    [PSCustomObject]@{
        SubDirectory = $subDirPath
        Size = $subDirSize
    }
}

# サブディレクトリの情報をテーブル形式で出力
$sizeInfo | Format-Table -AutoSize
