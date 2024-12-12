# crumb :root do
#   link "Home", root_path
# end

# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).

# 管理者ページ用のパンくずリスト設定
# ダッシュボードトップ
crumb :admin_root do
  link "Dashboard", admin_root_path
end

# 似てる曲組み合わせ一覧
crumb :admin_song_pairs do
  link "似てる曲組み合わせ", admin_song_pairs_path
  parent :admin_root
end

# 似てる曲組み合わせ編集
crumb :edit_admin_song_pair do |song_pair|
  link "#{song_pair.original_song.title} x #{song_pair.similar_song.title}", song_pair
  parent :admin_song_pairs
end