

#choose the proper node image.... https://hub.docker.com
FROM node:18-alpine as BUILD_IMAGE
WORKDIR /app/coolify-test


#copy package.json
COPY package.json .

# install all our packages

RUN npm install

# copy all our remaining files

COPY . .

# Finally build our project

RUN npm run build


# Here, we are implementing the multi-stage build. It greatly reduces our size
# It also won't expose our code in our container as we will only copy
# The build output from the first stage.


# beginning of second stage
FROM node:18-alpine as PRODUCTION_IMAGE
WORKDIR /app/coolify-test

# here, we are copying /app/coolify-test/dist folder from BUILD_IMAGE to
# /app/coolify-test/dist in this stage.


# Why dist folder ????
# When we run npm run build, vite will generate dist directory that contains
# Our build files


COPY --from=BUILD_IMAGE /app/coolify-test/dist/ /app/coolify-test/dist/
EXPOSE 8080

# to run npm commands as: npm run preview
# we need package.json
COPY package.json .
COPY vite.config.js .

# we also need typescript as this project is based on typescript.
RUN npm install typescript

EXPOSE 8080
CMD ["npm", "run", "preview"]


