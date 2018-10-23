module BreadcrumbsHelper
  def breadcrumbs
    degree = @degree || (@course.degree if @course) || (@package.course.degree if @package)
    course = @course || (@package.course if @package)
    package = @package 
    degree or course or package or return("")
    content_tag :nav do
      content_tag :ol, class: 'breadcrumb' do
        concat content_tag(:li, link_to('Home', root_path), class: "breadcrumb-item")
        if degree and ! degree.new_record?
          concat content_tag(:li, link_to(I18n.t(:degree) + ": #{degree}", degree), class: "breadcrumb-item")
        end
        if course and ! course.new_record?
          concat content_tag(:li, link_to(I18n.t(:course) + ": #{course}", course), class: "breadcrumb-item")
        end
        if package and ! package.new_record?
          concat content_tag(:li, link_to(I18n.t(:package) + ": #{package}", package), class: "breadcrumb-item")
        end
      end
    end
  end
end
