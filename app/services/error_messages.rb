module ErrorMessages
  # ==> Follow error messages
  def em_follow_not_found
    I18n.t('errors.messages.follow.not_found')
  end

  # ==> Sleep record error messages
  def em_sleep_records_not_found
    I18n.t('errors.messages.sleep_record.not_found')
  end
end
