# encoding: utf-8
class CardPageImportWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(page)
    ImportHelper::import_page_of_cards(page)
  end
end