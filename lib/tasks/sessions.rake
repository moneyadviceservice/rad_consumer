namespace :sessions do
  desc 'Delete expired sessions'
  task cleanup: :environment do
    ActiveRecord::SessionStore::Session.where('updated_at < ?', 1.month.ago).delete_all
  end
end
