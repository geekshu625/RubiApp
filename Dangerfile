# プロジェクトごとの変数定義

def xcodeproj_path

    return "RubiApp.xcodeproj"

end

## プロジェクト Workspace のパス
def xcworkspace_path

    return "RubiApp.xcworkspace"

end

## TODO:テスト用 Scheme 名をここで定義

## Info.plist パス
def info_plist_path

    return "RubiApp/Info.plist"

end

# GitHub Issue を探す
def find_github_issue

    issue = github.branch_for_head.match("feature/(\\d+)")
    if issue
        return issue
    end

end

# End プロジェクトごとの変数定義

# PR チェック結果を定義
class CheckResult

    attr_accessor :warnings, :errors, :title, :message

    def initialize(title)
        @warnings = 0
        @errors = 0
        @title = "## " + title
        @message = markdown_message_template
    end

    def markdown_message_template
        template = "確認項目 | 結果\n"
        template << "|--- | --- |\n"
        return template
    end

end

# APIKyeのファイルに差分がでていないか確認する
def check_apikey_file_has_been_modified

    modified_files = git.modified_files
    if modified_files.include?('APIKey.swift')
        warn('APIKeyが含まれている可能性があります。こちらのファイルを修正に含めないでください！', file: "./APIKey.swift", line: 1)
    end

end

# SwiftLint を導入して確認
def common_swiftlint_check

    swiftlint.config_file = '.swiftlint.yml'
    swiftlint.lint_files inline_mode: true

end

# PRにWIPが含まれているか確認する
def check_incled_wip_in_pr

    pr_title = github.pr_title
    if pr_title =~ /\[(wip)|(WIP)\]/
        warn("[WIP]の状態です。")
    end

end

def is_develop_pr

    ## とりあえず develop 向けの PR は develop PR とみなす
    is_to_develop = github.branch_for_base == "develop"
    if is_to_develop
        return true
    else
        return false
    end

end

# develop PR レビュールーチン
def develop_pr_check

    result = CheckResult.new("develop PR チェック")

    ## PR は `feature/`、`refactor/` 、`fix/`、`issue/` もしくは `version/` で始まるブランチから出す
    result.message << "PR From ブランチ確認 |"
    is_from_feature = github.branch_for_head.start_with?("feature/")

    if is_from_feature
        result.message << ":o:\n"
    else
        fail "デベロップ PR は Feature ブランチから出してください。"
        result.message << ":x:\n"
        result.errors += 1
    end

    ## PR は `develop` ブランチへ出す
    result.message << "PR To ブランチ確認 |"
    is_to_develop = github.branch_for_base == "develop"
    if is_to_develop
        result.message << ":o:\n"
    else
        fail "デベロップ PR は develop ブランチへマージしてください。"
        result.message << ":x:\n"
        result.errors += 1
    end

    ## PR の修正 500 行超えてはいけない
    result.message << "修正量確認 |"
    is_fix_too_big = git.lines_of_code > 500
    unless is_fix_too_big
        result.message << ":o:\n"
    else
        warn "修正が多すぎます。PR を小さく分割してください。"
        result.message << ":heavy_exclamation_mark:\n"
        result.warnings += 1
    end

    return result

end


# APIKyeのファイルに差分がでていたら警告を出す
check_apikey_file_has_been_modified

# SwiftLintのワーニング等確認
common_swiftlint_check

# PRにWIPが含まれていた警告をを出す
check_incled_wip_in_pr

github_issue = find_github_issue
if github_issue
    message "Resolve ##{github_issue[1]}"
end

develop_pr_check


## チェックルーチンの設定

if is_develop_pr
    check_result = develop_pr_check
end

if check_result
    markdown(check_result.title)
    markdown(check_result.message)

    if check_result.errors == 0 && check_result.warnings == 0
        message "よくできました:white_flower:"
    end

else
    fail "チェックルーチンが設定されていない PR です。PR を確認してください。"
end
