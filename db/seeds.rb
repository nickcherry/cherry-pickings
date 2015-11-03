if Rails.env.development?

  User.create!(
    name: 'Nick Cherry',
    email: 'nickcherryjiggz@gmail.com',
    password: '12345678'
  )

end
