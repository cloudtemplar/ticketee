module ApplicationHelper
  def title(*parts)
    unless parts.empty?
      content_for :title do
       (parts << "Ticketee").join(" - ") 
      end
    end
  end

  def admins_only(&block)
    block.call if current_user.try(:admin?)
  end

  # Adds rows in nested forms. Super useful!
  def link_to_add_field(name, f, association, **args)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.simple_fields_for(association, new_object) do |builder|
      render(association.to_s + '/' + association.to_s.singularize, f: builder)
    end
    link_to(name, '#', class: 'add_fields ' + args.fetch(:class, ""),
      data: { id: id, fields: fields.gsub("\n", "") })
  end
end
