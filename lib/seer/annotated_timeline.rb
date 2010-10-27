module Seer

  # =USAGE
  # 
  # In your controller:
  #
  #   @data = Widgets.all # Must be an array, and must respond
  #                       # to the data method specified below (in this example, 'quantity')
  #
  #   @series = @data.map{|w| w.widget_stats} # An array of arrays
  #
  # In your view:
  #
  #   <div id="chart"></div>
  #
  #   <%= Seer::visualize(
  #         @data, 
  #         :as => :annotated_timeline,
  #         :in_element => 'chart',
  #         :series => {
  #           :series_label => 'name',
  #           :data_label => 'date',
  #           :data_method => 'quantity',
  #           :data_series => @series
  #         },
  #         :chart_options => { 
  #           :height => 300,
  #           :width => 300,
  #           :axis_font_size => 11,
  #           :colors => ['#7e7587','#990000','#009900'],
  #           :title => "Widget Quantities",
  #           :point_size => 5
  #         }
  #        )
  #    -%>
  #
  # For details on the chart options, see the Google API docs at 
  # http://code.google.com/apis/visualization/documentation/gallery/annotated_timeline.html
  #
  class AnnotatedTimeline
  
    include Seer::Chart
    
    # Graph options
    attr_accessor :allow_html, :allow_redraw, :all_values_suffix, :annotations_width, :colors, :date_format    
    attr_accessor :display_annotations, :display_annotations_filter, :display_date_bar_separator, :display_exact_values
    attr_accessor :display_legend_dots, :display_legend_values, :display_range_selector, :display_zoom_buttons
    attr_accessor :fill, :highlight_dot, :legend_position, :max, :min, :number_formats, :scale_columns, :scale_type
    attr_accessor :thickness, :wmode, :zoom_end_time, :zoom_start_time
    
    # Graph data
    attr_accessor :series_label, :data_label, :data, :data_method, :data_series
    
    def initialize(args={}) #:nodoc:

      # Standard options
      args.each{ |method,arg| self.send("#{method}=",arg) if self.respond_to?(method) }

      # Chart options
      args[:chart_options].each{ |method, arg| self.send("#{method}=",arg) if self.respond_to?(method) }

      # Handle defaults      
      @colors ||= args[:chart_options][:colors] || DEFAULT_COLORS
      @legend ||= args[:chart_options][:legend] || DEFAULT_LEGEND_LOCATION
      @height ||= args[:chart_options][:height] || DEFAULT_HEIGHT
      @width  ||= args[:chart_options][:width] || DEFAULT_WIDTH

      @data_table = []
      
    end
  
    def data_columns #:nodoc:
      _data_columns =  "            data.addRows(#{data_rows.size});\r"
      _data_columns << "            data.addColumn('string', 'Date');\r"
      data.each do |datum|
        _data_columns << "            data.addColumn('number', '#{datum.send(series_label)}');\r"
      end
      _data_columns
    end
    
    def data_table #:nodoc:
      _rows = data_rows
      _rows.each_with_index do |r,i|
        @data_table << "            data.setCell(#{i}, 0,'#{r}');\r"
      end
      data_series.each_with_index do |column,i|
        column.each_with_index do |c,j|
          @data_table << "            data.setCell(#{j},#{i+1},#{c.send(data_method)});\r"
        end
      end
      @data_table
    end
    
    def data_rows
      data_series.inject([]) do |rows, element|
        rows |= element.map { |e| e.send(data_label) }
      end
    end

    def nonstring_options #:nodoc:
      [ :allow_html, :allow_redraw, :display_annotations, :display_exact_values, :display_legend_dots, :display_legend_values, :display_range_selector, :display_zoom_buttons, :scale_columns, :annotations_width, :display_date_bar_separator, :display_annotations_filter, :fill, :colors, :max, :min, :thickness, :zoom_end_time, :zoom_start_time]
    end
    
    def string_options #:nodoc:
      [ :all_values_suffix, :date_format, :highlight_dot, :legend_position, :number_formats, :scale_type, :wmode ]
    end
    
    def to_js #:nodoc:

      %{
          google.load('visualization', '1', {'packages':['annotatedtimeline']});
          google.setOnLoadCallback(drawChart);
          function drawChart() {
            var data = new google.visualization.DataTable();
#{data_columns}
#{data_table.to_s}
            var options = {};
#{options}
            var container = document.getElementById('#{self.chart_element}');
            var chart = new google.visualization.AnnotatedTimeline(container);
            chart.draw(data, options);
          }
      }
    end
      
    def self.render(data, args) #:nodoc:
      graph = Seer::AnnotatedTimeline.new(
        :data => data,
        :series_label   => args[:series][:series_label],
        :data_series    => args[:series][:data_series],
        :data_label     => args[:series][:data_label],
        :data_method    => args[:series][:data_method],
        :chart_options  => args[:chart_options],
        :chart_element  => args[:in_element] || 'chart'
      )
      graph.to_js
    end
    
  end  

end
