require 'nokogiri'

class ANKIHTML
 def replace_img(htmlstr)
    cfdoc = Nokogiri::HTML::fragment(htmlstr);
    cfdoc.xpath("//img").each |img|
    image_tag = "<%= image_tag('#{img['src']}') %>"
    img.replace(cfdoc.create_text_node(image_tag))
    return cfdoc.to_html
    #@cards = Card.find(params[:id])
  end
end  
