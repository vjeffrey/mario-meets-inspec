FROM ruby:alpine

RUN apk add --update build-base libxml2-dev libffi-dev

CMD ["/bin/sh"]
