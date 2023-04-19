FROM node:14

WORKDIR /app

ENV PATH /app/node_modules/.bin:$PATH

COPY . ./

# RUN yarn install

EXPOSE 3000

CMD ["yarn", "start"]