# ------------------------------------------------------------------------------
# BUILD STAGE
# ------------------------------------------------------------------------------
FROM node:8 as builder

# add `/usr/src/app/node_modules/.bin` to $PATH
ENV PATH /usr/src/app/node_modules/.bin:$PATH

RUN apt-get update \
  && apt-get install --no-install-recommends --no-install-suggests -yq \
    curl \
    git \
  && rm -rf /var/lib/apt/lists/* \
  # && git clone --depth=1 https://github.com/docker/docker-bench-security.git /docker-bench-security && rm -rf !$/.git \
  # && chmod -R 755 /docker-bench-security \
  # set working directory
  && mkdir -p /usr/src/app

WORKDIR /usr/src/app

# install and cache app dependencies
COPY package.json /usr/src/app/
RUN npm install

# Copy the current directory contents into the container at /app
ADD . /usr/src/app

# RUN echo "Running tests, builds, and re-installing only production dependencies" \
#   && npm run ci \
#   && rm -Rf node_modules \
#   && npm install --only=prod

# ------------------------------------------------------------------------------
# FINAL STAGE
# ------------------------------------------------------------------------------
FROM node:8-alpine

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

# copy artifact build from the 'build environment'
COPY --from=builder /usr/src/app/api /usr/src/app/api
COPY --from=builder /usr/src/app/controllers /usr/src/app/controllers
COPY --from=builder /usr/src/app/node_modules /usr/src/app/node_modules
COPY --from=builder /usr/src/app/service /usr/src/app/service
COPY --from=builder /usr/src/app/utils /usr/src/app/utils

COPY --from=builder \
  /usr/src/app/index.js \
  /usr/src/app/package-lock.json \
  /usr/src/app/package.json \
  /usr/src/app/

# RUN ls -al /usr/src/app

EXPOSE 8200

# start app
CMD node index.js

# HEALTHCHECK --interval=5m --timeout=7s \
#   CMD curl -f http://localhost:8200/health || exit 1
