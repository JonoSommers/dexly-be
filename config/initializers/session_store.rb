Rails.application.config.session_store :cookie_store,
    key: "_dexly_session",
    same_site: :lax,
    secure: false # change to true in production with HTTPS
