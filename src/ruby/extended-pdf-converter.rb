
class PDFConverterCustomChapterTitle < (Asciidoctor::Converter.for 'pdf')
    register_for 'pdf'

  def ink_chapter_title node, title, opts = {}
  
    require 'logger'

    logger = Logger.new(STDOUT)
    logger.level = Logger::DEBUG
    logger.formatter = proc do |severity, datetime, progname, msg| 
      "#{severity} - #{msg}\n" 
    end
  
    # Conditionally set the amount to relocate the cursor
    # based on the section title
    case title
    when /Preface/
      move_x = 326
      move_y = 162
    when /Acknowledgements/
      move_x = 250
      move_y = 162
    when /Chapter/
      move_x = 314
      move_y = 191
    when /Appendix A/
      move_x = 126
      move_y = 162
    when /Appendix B/
      move_x = 141
      move_y = 162
    when /Index/
      move_x = 321
      move_y = 161
    else
      logger.debug "No match for #{title}"
      move_x = 300
      move_y = 162
    end

    title_array = title.split('.')
    if title_array[1] != nil
      title_array[1].index(':') != nil ? 
      title_and_commands_array = (title_array[1]).split(':') :
      title_and_commands_array = [title_array[1], '']
      new_title = title_and_commands_array[0]
      command_list = title_and_commands_array[1]
    end

    font_families.update(
      'PT Sans Narrow' => {
        normal: "./styles/pdf/fonts/PTSansNarrow-Regular.ttf",
        bold: "./styles/pdf/fonts/PTSansNarrow-Bold.ttf",
      },
    )

    # "Chapter 2"
    logger.debug "BEGIN #{title} -----------------------"
    signifier = title_array[0].upcase
    logger.debug "Writing #{signifier}. Cursor is now: #{cursor}"
    text(signifier, 
      align: :right,
      text_transform: 'uppercase',
      font: 'PT Sans Narrow',
      style: :normal,
      color: '292524',
      size: '0.75em'
    )
    logger.debug "Wrote #{signifier}. Cursor is now: #{cursor}"
  
    stroke_horizontal_rule '292524' , line_width: 0.5
    logger.debug "Wrote HZ rule. Cursor is now: #{cursor}"

    ink_heading new_title, (opts.merge)
    logger.debug "Wrote #{new_title} Cursor is now: #{cursor}"

    move_up move_y
    logger.debug "Moved up #{move_y}. Cursor is now: #{cursor}"

    # The ornament is 280x128 pixels, so downsize it to 11%
    # to fit on the heading line
    img_width = 280 * 0.11
    img_height = 128 * 0.11
    image "./images/logo-header-ornament.svg", fit: [img_width, img_height], at: [move_x, cursor]
    logger.debug "Wrote image. Cursor is now: #{cursor}"

    move_down 155
    logger.debug "Moved down 155. Cursor is now: #{cursor}"
    
    if command_list != nil && command_list.size > 0
      logger.debug("Command list size: #{command_list.size}")
      move_y = 105
      move_up move_y
      logger.debug "Moved up #{move_y}. Cursor is now: #{cursor}"
      text(command_list, 
        align: :right,
        font: 'PT Sans Narrow',
        style: :normal,
        color: '292524',
        size: '0.75em'
      )
      logger.debug "Wrote #{command_list}. Cursor is now: #{cursor}"

      move_down 85
      logger.debug "Moved down 90. Cursor is now: #{cursor}"
    end
    logger.debug "END #{title} -----------------------\n"
  end
end