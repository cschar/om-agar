defmodule Om.Auth do
	import Plug.Conn
	import Phoenix.Controller
	alias OmWeb.Router.Helpers


	def init(opts) do
		Keyword.fetch!(opts, :repo)
	end

	def call(conn, repo) do

		user_id = get_session(conn, :user_id)

		if user = user_id && repo.get(Om.User, user_id) do
			put_current_user(conn, user)
		else
			assign(conn, :current_user, nil)
		end

	end

	def login(conn, user) do
		conn
		|> assign(:current_user, user)
		|> put_session(:user_id, user.id)
		|> configure_session(renew: true)
	end

	defp put_current_user(conn, user) do
		token = Phoenix.Token.sign(conn, "user socket", user.id)

		conn
		|> assign(:current_user, user)
		|> assign(:user_token, token)

	end

	def logout(conn) do
		configure_session(conn, drop: true)
	end

	def authenticate_user(conn, _opts) do
		if conn.assigns.current_user do
			conn
		else
			conn
			|> put_flash(:error, "You must choose a username to access that page")
			|> redirect(to: Helpers.page_path(conn, :index))
			|> halt()
		end
	end
end