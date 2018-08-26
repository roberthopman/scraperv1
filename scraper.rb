require 'watir'
require 'watir-scroll'

site = ""

browser = Watir::Browser.new
browser.goto site
headers = Array.new
names = Array.new
hrefs = Array.new

(1..3).each do |n|
    column = browser.element(id: 'col' + n.to_s)
    if column.exists?
      blocks = column.divs(:class => %w(block link))

      blocks.each do |block|
        if block.element(class: 'title').exists?
          header = block.element(class: 'title').text
          headers << header

          more = block.element(class: "more")
          if more.present?
            more.scroll.to :center
            50.times do
              more.scroll.by 0,0
            end

            more.scroll.to :center
            more.click

            if more.span(text: "less").present?
              more.span(text: "less").to :center
            else
              until more.span(text: "less").present? || more.span(text: "less").exists?
                200.times do
                  more.scroll.by 0,0
                end
              end
            end
          end

          puts "# #{header}"
          puts "\n"

          block.elements(class: %w(actionable link)).each do |link|
            name =  link.span(class: "text").text
            href = link.a.href
            names << name
            hrefs << href
            puts "- [#{name}](#{href})"
          end

          puts "\n"
        end
      end

      # p blocks
      # p headers.count
      # p names.count
      # p hrefs.count
    end
end
