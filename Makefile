env\:encrypt: .env
	openssl aes-256-cbc -in .env -out .env.enc -pass file:$$TEAM_SECRET_KEY
	@touch .env.enc

env\:decrypt: .env.enc
	openssl aes-256-cbc -d -in .env.enc -out .env -pass file:$$TEAM_SECRET_KEY
	@touch .env
