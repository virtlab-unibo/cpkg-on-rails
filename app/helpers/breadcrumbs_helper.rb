module BreadcrumbsHelper
  def breadcrumbs
    degree = @degree || (@course.degree if @course) || (@package.course.degree if @package)
    course = @course || (@package.course if @package)
    package = @package 
    degree or course or package or return("")
    content_tag :nav do
      content_tag :ol, class: 'breadcrumb' do
        concat content_tag(:li, link_to('Home', root_path), class: "breadcrumb-item")
        if degree
          concat content_tag(:li, link_to(degree, degree), class: "breadcrumb-item")
        end
        if course
          concat content_tag(:li, link_to(course, course), class: "breadcrumb-item")
        end
        if package
          concat content_tag(:li, link_to(package, package), class: "breadcrumb-item")
        end
      end
    end
  end
end
