MAKE_TEXT_SPECIAL = \033[38;5;124;48;5;189m
SPECIAL_TEXT_END = \033[0m

login:
	aws ecr get-login-password --profile=neulhan --region ap-northeast-2 | docker login --username AWS --password-stdin 137604332361.dkr.ecr.ap-northeast-2.amazonaws.com

build:
	@echo "\n$(MAKE_TEXT_SPECIAL)✦ 새로운 이미지를 빌드합니다. ✦$(SPECIAL_TEXT_END)\n"
	docker build -t prc-server-fastapi .
	docker tag prc-server-fastapi:latest 137604332361.dkr.ecr.ap-northeast-2.amazonaws.com/prc-server-fastapi:latest

push:
	@echo "\n$(MAKE_TEXT_SPECIAL)✦ ECR 에 푸시합니다. ✦$(SPECIAL_TEXT_END)\n"
	docker push 137604332361.dkr.ecr.ap-northeast-2.amazonaws.com/prc-server-fastapi:latest

run:
	docker run -p8000:80 prc-server-fastapi:latest