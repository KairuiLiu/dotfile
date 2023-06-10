const fetch = require('node-fetch');

function fix2dig(num) {
  if (num < 10) return '0' + num;
  return num;
}

(async function reqCurrency() {
  const st = new Date();
  await fetch(
    `https://www.unionpayintl.com/upload/jfimg/${st.getFullYear()}${fix2dig(
      st.getMonth() + 1
    )}${fix2dig(st.getDate())}.json`
  )
    .then((response) => response.json())
    .then((response) =>
      console.log(
        'NZD: ' +
          response.exchangeRateJson.find(
            (d) => d.transCur === 'NZD' && d.baseCur === 'CNY'
          )?.rateData
      )
    )
    .catch((err) => {
      console.log(err);
    });
})();
