require 'test_helper'

class PasswordCreationTest < ActionDispatch::IntegrationTest
  def test_password_creation
    get '/'
    assert_response :success

    post '/p', params: { password: { payload: 'testpw' } }
    assert_response :redirect

    # Preview page
    follow_redirect!
    assert_response :success
    assert_select 'h2', 'Your password has been pushed.'

    # Password page
    get request.url.sub('/preview', '')
    assert_response :success
    assert_select 'p', 'Your password is blurred below.  Click to reveal it.'

    # Assert that the right password is in the page
    divs = css_select 'div#pass'
    assert(divs)
    assert(divs.first.content.include?('testpw'))

    # Reload the password page, we should not have the first view share note
    get request.url
    assert_response :success
    assert_select 'p', 'Your password is blurred below.  Click to reveal it.'
    div = css_select 'div.share_note'
    assert div.length.zero?

    # Assert that the right password is in the page
    divs = css_select 'div#pass'
    assert(divs)
    assert(divs.first.content.include?('testpw'))
  end

  def test_password_creation_uncommon_characters
    get '/'
    assert_response :success

    post '/p', params: { password: { payload: '£' } }
    assert_response :redirect

    # Preview page
    follow_redirect!
    assert_response :success
    assert_select 'h2', 'Your password has been pushed.'

    # Password page
    get request.url.sub('/preview', '')
    assert_response :success
    assert_select 'p', 'Your password is blurred below.  Click to reveal it.'

    # Assert that the right password is in the page
    divs = css_select 'div#pass'
    assert(divs)
    assert(divs.first.content.include?('£'))

    # Reload the password page, we should not have the first view share note
    get request.url
    assert_response :success
    assert_select 'p', 'Your password is blurred below.  Click to reveal it.'
    div = css_select 'div.share_note'
    assert div.length.zero?

    # Assert that the right password is in the page
    divs = css_select 'div#pass'
    assert(divs)
    assert(divs.first.content.include?('£'))
  end

  def test_deletable_by_viewer_enabled_or_not
    get '/'
    assert_response :success

    # DELETABLE_BY_VIEWER_PASSWORDS enables or disables the ability for users
    # to delete passwords when viewing
    dvb_checkbox = css_select 'p.notes'
    assert(dvb_checkbox.length > 1)

    found = DELETABLE_BY_VIEWER_PASSWORDS
    dvb_checkbox.each do |item|
      if item.content.include?('Allow viewers to optionally delete password before expiration')
        found = true
      end
    end
    assert found

    # Assert default value on form: DELETABLE_BY_VIEWER_DEFAULT
    dvb_checkbox = css_select 'input#password_deletable_by_viewer'
    assert(dvb_checkbox.length == 1)

    # DELETABLE_BY_VIEWER_DEFAULT determines initial check state
    if DELETABLE_BY_VIEWER_DEFAULT == true
      assert(dvb_checkbox.first.attributes['checked'].value == 'checked')
    else
      assert(dvb_checkbox.first.attributes['checked'].nil?)
    end
  end

  def test_deletable_by_viewer_honored_when_true
    get '/'
    assert_response :success

    post '/p', params: { password: { payload: 'testpw', deletable_by_viewer: 'on' } }
    assert_response :redirect

    follow_redirect!
    assert_response :success

    # Password page
    get request.url.sub('/preview', '')
    assert_response :success
    assert_select 'p', 'Your password is blurred below.  Click to reveal it.'

    password_id = request.path.split('/')[2]
    delete_link = css_select "button.red-button"
    assert(delete_link.length == 1)
    assert(delete_link.first.child.content.include?('Delete This Secret Link Now'))
  end

  def test_deletable_by_viewer_falls_back_to_default
    get '/'
    assert_response :success

    post '/p', params: { password: { payload: 'testpw' } }
    assert_response :redirect

    follow_redirect!
    assert_response :success

    # Password page
    get request.url.sub('/preview', '')
    assert_response :success

    assert_select 'p', 'Your password is blurred below.  Click to reveal it.'

    password_id = request.path.split('/')[2]
    delete_link = css_select "a##{password_id}"

    # HTML Form Checkboxes: when NOT checked the form attribute isn't submitted
    # at all so we set false - NOT deletable by viewers
    assert(delete_link.length.zero?)
  end
end
