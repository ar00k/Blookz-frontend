FROM oven/bun:1

WORKDIR /app

# Kopiujemy package.json i lockfile
COPY package.json bun.lock ./

RUN bun install

# Kopiujemy resztę projektu
COPY . .

EXPOSE 5173

CMD ["bun", "run", "dev", "--host"]
