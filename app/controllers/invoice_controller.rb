class InvoiceController < ApplicationController

  def show
    raise ActiveRecord::RecordNotFound unless Rails.env.development?

    @membership = Membership.find(params[:id])
    respond_to do |format|
      format.pdf do
        render show_as_html: params.has_key?(:debug),
          pdf: "#{Date.today.iso8601} Ruby Together Invoice",
          margin: {top: 0, right: 0, bottom: 0, left: 0}
      end
    end
  end

end
