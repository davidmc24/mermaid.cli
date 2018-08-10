FROM zenato/puppeteer

USER root
WORKDIR /data

ADD index.* package.json yarn.lock defaultPuppeteerConfig.json ./
RUN npm install --only=dev && /data/node_modules/.bin/babel ./index.js --out-file ./index.bundle.js
RUN npm install && cp ./node_modules/mermaid/dist/mermaid.min.js .

USER pptruser

ADD test ./test
RUN node index.bundle.js --puppeteerConfigFile defaultPuppeteerConfig.json -i ./test/flowchart.mmd -o /tmp/test.png; rm /tmp/test.png

ENTRYPOINT ["node", "/data/index.bundle.js", "--puppeteerConfigFile", "/data/defaultPuppeteerConfig.json"]
CMD ["--help"]
