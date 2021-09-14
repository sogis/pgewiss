DROP VIEW IF EXISTS oekomorph_v;

CREATE VIEW oekomorph_v AS 

WITH

measure AS (
  SELECT
    ST_LineLocatePoint(netz.geom, ST_StartPoint(seg.geom)) AS m1,
    ST_LineLocatePoint(netz.geom, ST_EndPoint(seg.geom)) AS m2,
    seg.id,
    netz.geom AS ng
  FROM
    oekomorph seg
  JOIN
    basisnetz netz ON seg.gnrso = netz.gnrso   
)

SELECT 
  m.id,
  attr.sohlenbreite,
  ST_LineSubstring(ng, LEAST(m1, m2), GREATEST(m1, m2))::geometry(LINESTRING, 2056) AS geom
FROM
  measure m
JOIN
  oekomorph attr ON m.id = attr.id

 