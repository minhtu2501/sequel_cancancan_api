require './app/errors/bad_request.rb'
require './app/errors/resource_not_found.rb'
module APIErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from CanCan::AccessDenied do |e|
    error_response(
      { message: 
        { 
          meta:{
            status: :failed ,
            code: 404,
            messages: "Access denied. You are not authorized to access the requested page."
          },
          data: nil
        }, 
        status: 404 
      })
    end

    rescue_from BadRequest do |e|
      error_response(
        { 
          message: 
          {
            meta:{
              status: :failed ,
              code: 400,
              messages: "Bad request"
            },
            data: nil
          }, 
          status: 400 
        })
    end

    rescue_from ResourceNotFound do |e|
      error_response(
        { 
          message: 
          { 
            meta:{
              status: :failed ,
              code: 404,
              messages: "は見つかりませんでした。"
            },
            data: nil
          }, 
          status: 404 
        })
    end

    rescue_from :all do |e|
      error_response(
        { 
          message: 
          { 
            meta:{
              status: :failed ,
              code: 500,
              messages: "Internal server error occurred."
            },
            data: nil
          }, 
          status: 500 
        })
    end
  end
end
