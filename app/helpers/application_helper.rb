module ApplicationHelper
	def flash_notifications
    message = flash[:error] || flash[:notice]

    if message
      type = flash.keys[0].to_s
      javascript_tag %Q{$.notification({ message:"#{message}", type:"#{type}" });}
    end
  end
  
  def fading_flash_notice
    # note: you must have a div with id='notices' or rename the div appended to below with your element which
    # is the container for the flash messages
    return '' if !flash[:notice]
    notice_id = rand.to_s.gsub(/\./, '')
    notice = #{flash[:notice]}");
      $("##{notice_id}").fadeOut(5000);
    EOF
    notice.html_safe
  end

end
