let myHandler = async function (event, context, callback, logger) {
  logger.info(JSON.stringify(event));

  // do something here

  callback({
    code: 0,
    desc: "Success."
  });
};

export { myHandler };