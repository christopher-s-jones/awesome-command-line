class PDFConverterCustomChapterTitle < (Asciidoctor::Converter.for 'pdf')
    register_for 'pdf'
  
    # def ink_chapter_title node, title, opts = {}
    #   move_down cursor * 0.25
    #   ink_heading title, (opts.merge align: :center, text_transform: :uppercase)
    #   stroke_horizontal_rule 'DDDDDD', line_width: 1
    #   move_down theme.block_margin_bottom
    #   theme_font :base do
    #     layout_prose 'Custom text here, maybe a chapter preamble.'
    #   end
    #   start_new_page
    # end

  def ink_chapter_title node, title, opts = {}
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
    signifier = title_array[0].upcase
    text(signifier, 
      align: :right,
      text_transform: 'uppercase',
      font: 'PT Sans Narrow',
      style: :normal,
      color: '292524',
      size: '0.75em'
    )

    stroke_horizontal_rule '292524' , line_width: 0.5
    # stroke_color 'FF0000'
    # stroke do
    #   vertical_line 100, 400, at: 300
    # end
    ink_heading new_title, (opts.merge)
    move_up 192
    image "./images/logo-header-ornament.svg", fit: [15.7, 19.7]
    move_down 185

    if command_list != nil
      move_up 135
      text(command_list, 
        align: :right,
        font: 'PT Sans Narrow',
        style: :normal,
        color: '292524',
        size: '0.75em'
      )
      move_down 135
    end
  end
end