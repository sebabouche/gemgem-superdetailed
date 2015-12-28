module Gemgem::Cell
  module GridCell
    def self.included(base)
      base.inheritable_attr :classes
    end

    def classes
      classes = self.class.classes.clone
      classes << "end" if options[:last] == model
      classes
    end

    def container(&block)
      content_tag(:div, class: classes, &block)
    end
  end
end
