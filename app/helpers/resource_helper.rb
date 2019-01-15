# frozen_string_literal: true

module ResourceHelper
  def btn(klass, name, path)
    classes = %w[btn btn-outline btn-sm] + ["btn-#{klass}"]
    link_to(name, path, class: classes.join(' '))
  end

  def new_button(path)
    btn(:primary, 'New', path)
  end

  def show_button(path)
    btn(:primary, 'Show', path)
  end

  def back_button(_path)
    btn(:default, 'Back', :back)
  end

  def edit_button(path)
    btn(:warning, 'Edit', path)
  end

  def destroy_button(path)
    link_to('Destroy', path, method: :delete,
                             data: { confirm: 'Are you sure?' },
                             class: 'btn btn-danger btn-outline btn-sm')
  end
end
