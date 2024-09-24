# 베이스 이미지로 Node.js LTS 사용
FROM node:18-alpine

# pnpm 설치
RUN npm install -g pnpm

# 작업 디렉터리 설정
WORKDIR /app

# package.json과 pnpm-lock.yaml 복사 (의존성 설치를 위해)
COPY package.json pnpm-lock.yaml ./

# 의존성 설치
RUN pnpm install

# 모든 파일을 컨테이너로 복사
COPY . .

# 포트 설정
EXPOSE 8080

# 환경 변수 설정
ENV NODE_ENV development

# 개발 서버 실행
CMD ["pnpm", "run", "serve"]
