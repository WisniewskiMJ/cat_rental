# frozen_string_literal: true

module ApplicationHelper
  def age(cat)
    time_ago_in_words(cat.birth_date)
  end

  def navbar_items
    if current_user
      render 'shared/user_navbar_items'
    else
      render 'shared/no_user_navbar_items'
    end
  end

  def rental_form_cat_name(cat, cats, form)
    if !cat
      render 'cat_rental_requests/form_cat_pick_name', cats: cats, form: form
    else
      render 'cat_rental_requests/form_cat_show_name', cats: cats, form: form
    end
  end

  def requests(subject, page)
    cat_requests = if page == :cat
                     subject.rental_requests.order(:start_date)
                   else
                     subject.requests.order(:start_date)
                   end
    render 'cat_rental_requests/requests', cat_requests: cat_requests, page: page
  end

  def requests_details(page, request)
    if page == :cat
      render 'shared/request_details', request: request, name: request.requester.username, page: page
    else
      render 'shared/request_details', request: request, name: request.cat.name, page: page
    end
  end

  def request_processing(request, page)
    return unless page == :cat
    return unless request.status == 'pending' && current_user && current_user.id == request.cat.owner.id

    render 'cat_rental_requests/request_processing', request: request
  end

  def cat_form(cat, action)
    if cat.persisted?
      action_url = cat_url(cat)
      method = :patch
      submit = 'Update cat'
    else
      action_url = cats_url
      method = :post
      submit = 'Add cat'
    end
    render 'cats/cat_form', cat: cat, action: action, action_url: action_url, method: method,
                            submit: submit
  end

  def user_form(user, action)
    case action
    when :register
      action_url = users_url
      method = :post
      submit = 'Register'
      password_label = 'Password (min. 6 characters)'
    when :login
      action_url = session_url
      method = :post
      submit = 'Log in'
      password_label = 'Password'
    when :edit
      action_url = user_url
      method = :patch
      submit = 'Submit'
      password_label = 'New password'
    end
    render 'shared/user_form', user: user, action: action, action_url: action_url, method: method,
                               submit: submit, password_label: password_label
  end

  def cat_processing(cat)
    return unless current_user

    if current_user.id == cat.owner.id
      render 'cats/cat_owner_processing', cat: cat
    else
      render 'cats/cat_user_processing', cat: cat
    end
  end

  def display_flash
    return if flash.empty?

    render 'shared/flash'
  end

  def cat_image(cat)
    placeholder = '/images/cat_default.jpg'
    if cat.pic.attached?
      render 'cats/cat_image', cat: cat, image: cat.pic
    else
      render 'cats/cat_image', cat: cat, image: placeholder
    end
  end
end
