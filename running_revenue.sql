SELECT
  date,
  sum(total_price) OVER (ORDER BY date) AS running_revenue,
  sum(total_predict) OVER (ORDER BY date) AS running_predict,
  sum(total_price) OVER (ORDER BY date) / sum(total_predict) OVER (ORDER BY date) * 100 AS completed_predict_percent
FROM
  (
    SELECT
      date, sum(sum_price) AS total_price, sum(sum_predict) AS total_predict
    FROM
      (
        SELECT s.date, sum(p.price) AS sum_price, 0 AS sum_predict
        FROM `data-analytics-mate.DA.product` p
        JOIN `data-analytics-mate.DA.order` o
          ON p.item_id = o.item_id
        LEFT JOIN `data-analytics-mate.DA.session` s
          ON o.ga_session_id = s.ga_session_id
        GROUP BY s.date
        UNION ALL
        SELECT date, 0 AS sum_price, sum(predict) AS sum_predict
        FROM `data-analytics-mate.DA.revenue_predict`
        GROUP BY date
      )
    GROUP BY date
  )
