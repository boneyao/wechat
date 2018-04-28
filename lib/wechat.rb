require 'wechat/api_loader'
require 'wechat/api'
require 'wechat/mp_api'
require 'wechat/corp_api'
require 'wechat/helpers'
require 'action_controller/wechat_responder'

module Wechat
  autoload :Message, 'wechat/message'
  autoload :Responder, 'wechat/responder'
  autoload :Cipher, 'wechat/cipher'
  autoload :Decryptor, 'wechat/decryptor'
  autoload :ControllerApi, 'wechat/controller_api'

  class AccessTokenExpiredError < StandardError; end
  class InvalidCredentialError < StandardError; end
  class InvalidCodeError < StandardError; end
  class ResponseError < StandardError
    attr_reader :error_code
    def initialize(errcode, errmsg)
      @error_code = errcode
      super "#{errmsg}(#{error_code})"
    end
  end

  def self.config(account = :default)
    ApiLoader.config(account)
  end

  def self.api(account = :default)
    @wechat_apis ||= {}
    @wechat_apis[account.to_sym] ||= ApiLoader.with(account: account)
  end

  def self.reload_config!
    ApiLoader.reload_config!
  end

  def self.decrypt(encrypted_data, session_key, iv)
    Decryptor.new(encrypted_data, session_key, iv).decrypt
  end
end

ActionView::Base.send :include, Wechat::Helpers if defined? ActionView::Base
