/*
Описание документов MongoDB:
    emissions — данные о выбросах (страна, год, показатель CO₂, допустимые нормы).
    animals — наблюдения за животными (вид, регион, год, численность, редкость).
    pollution — показатели загрязнения воздуха (город, дата/год, уровень загрязнения, допустимый уровень).
    projects — экологические проекты (название, страна, тип проекта, даты начала и окончания, площадь/объём работ, организация).
    organizations — экологические организации (id, название, сфера деятельности).
    waste — данные об отходах (тип отхода, страна, способ утилизации/переработки).
    water_quality — качество воды (водоём, дата, содержание тяжёлых металлов и других веществ).
*/

db.emissions.insertMany([
  { _id: 1, country: "Россия", year: 2020, CO_2: 10000, permissible_limits: 1000 },
  { _id: 2, country: "Россия", year: 2021, CO_2: 11000, permissible_limits: 1000 },
  { _id: 3, country: "Россия", year: 2022, CO_2: 12000, permissible_limits: 1000 },
  { _id: 4, country: "Россия", year: 2023, CO_2: 13000, permissible_limits: 1000 },
  { _id: 5, country: "США", year: 2020, CO_2: 20000, permissible_limits: 1000 },
  { _id: 6, country: "США", year: 2021, CO_2: 21000, permissible_limits: 1000 },
  { _id: 7, country: "США", year: 2022, CO_2: 220000, permissible_limits: 1000 },
  { _id: 8, country: "США", year: 2023, CO_2: 22000, permissible_limits: 1000 }
]);

db.animals.insertMany([
    { _id: 1, species: "squirrel", region: "Москва", year: 2020, population: 100000, rarity: 0},
    { _id: 2, species: "squirrel", region: "Москва", year: 2021, population: 101000, rarity: 0},
    { _id: 3, species: "squirrel", region: "Москва", year: 2022, population: 101200, rarity: 0},
    { _id: 4, species: "squirrel", region: "Москва", year: 2023, population: 101100, rarity: 0},
 
    { _id: 5, species: "squirrel", region: "Ленинградская область", year: 2020, population: 200000, rarity: 0},
    { _id: 6, species: "squirrel", region: "Ленинградская область", year: 2021, population: 201000, rarity: 0},
    { _id: 7, species: "squirrel", region: "Ленинградская область", year: 2022, population: 201200, rarity: 0},
    { _id: 8, species: "squirrel", region: "Ленинградская область", year: 2023, population: 201100, rarity: 0},
    { _id: 9, species: "squirrel", region: "Ленинградская область", year: 2024, population: 201110, rarity: 0},
    { _id: 10, species: "bear", region: "Ленинградская область", year: 2024, population: 110, rarity: 0}
 ]);

 db.pollution.insertMany([
    { _id: 1, city: "Москва", year: new Date("2020-01-01"), pollution_level: 100000, permissible_limit: 110000},
    { _id: 2, city: "Москва", year: new Date("2021-01-01"), pollution_level: 110000, permissible_limit: 110000},
    { _id: 3, city: "Москва", year: new Date("2022-01-01"), pollution_level: 111000, permissible_limit: 110000},
    { _id: 4, city: "Москва", year: new Date("2023-01-01"), pollution_level: 111100, permissible_limit: 110000},

    { _id: 5, city: "Санкт-Петербург", year: new Date("2020-01-01"), pollution_level: 100000, permissible_limit: 110000},
    { _id: 6, city: "Санкт-Петербург", year: new Date("2021-01-01"), pollution_level: 110000, permissible_limit: 110000},
    { _id: 7, city: "Санкт-Петербург", year: new Date("2022-01-01"), pollution_level: 111000, permissible_limit: 110000},
    { _id: 8, city: "Санкт-Петербург", year: new Date("2023-01-01"), pollution_level: 111100, permissible_limit: 110000}

 ]);

db.projects.insertMany([
   { _id: 1, name: "Редкие белки Москвы", country: "Россия", project_type: 0, beg_date: new Date("2020-01-01"), end_date: new Date("2022-01-01"), volume: 10000, organization: "Белки МСК" },
   { _id: 2, name: "Редкие белки Москвы", country: "Россия", project_type: 0, beg_date: new Date("2023-01-01"), end_date: new Date("2024-01-01"), volume: 11000, organization: "Белки МСК" },
   { _id: 3, name: "Редкие белки России", country: "Россия", project_type: 0, beg_date: new Date("2020-01-01"), end_date: new Date("2023-01-01"), volume: 10000, organization: "Белки СПб" },
   { _id: 4, name: "Редкие белки США", country: "США", project_type: 0, beg_date: new Date("2020-01-01"), end_date: new Date("2023-01-01"), volume: 10000, organization: "Белки Вашингтона" }
]);


db.organizations.insertMany([
//     — экологические организации (id, название, сфера деятельности).
   { _id: 1, id: 1, name: "Белки МСК", field_of_activity: "0" },
   { _id: 2, id: 2, name: "Белки СПб", field_of_activity: "1" },
   { _id: 3, id: 3, name: "Белки Вашингтона", field_of_activity: "2" }
]);


db.waste.insertMany([
//     — данные об отходах (тип отхода, страна, способ утилизации/переработки).
   { _id: 1, waste_type: "0", country: "Россия", recycling_method: "сжечь" },
   { _id: 2, waste_type: "1", country: "Россия", recycling_method: "закопать" },
   { _id: 3, waste_type: "0", country: "США", recycling_method: "сжечь" },
   { _id: 4, waste_type: "1", country: "США", recycling_method: "закопать" },
]);

db.water_quality.insertMany([
//     — качество воды (водоём, дата, содержание тяжёлых металлов и других веществ).
   { _id: 1, reservoir: "Байкал", date: new Date("2020-01-01"), heavy_metal_content: 100 },
   { _id: 2, reservoir: "Байкал", date: new Date("2021-01-01"), heavy_metal_content: 101 },
   { _id: 3, reservoir: "Байкал", date: new Date("2022-01-01"), heavy_metal_content: 102 },
   { _id: 4, reservoir: "Байкал", date: new Date("2023-01-01"), heavy_metal_content: 102 },

   { _id: 5, reservoir: "Мичиган", date: new Date("2020-01-01"), heavy_metal_content: 100 },
   { _id: 6, reservoir: "Мичиган", date: new Date("2021-01-01"), heavy_metal_content: 100 },
   { _id: 7, reservoir: "Мичиган", date: new Date("2022-01-01"), heavy_metal_content: 101 },
   { _id: 8, reservoir: "Мичиган", date: new Date("2023-01-01"), heavy_metal_content: 101 },
]);


// Для каждого вида животного подсчитать количество наблюдений по регионам и вывести регионы с наибольшим числом наблюдений.
db.animals.aggregate([
  {
    $group: {
      _id: {
        species: "$species",
        region: "$region"
      },
      count: { $sum: 1 }
    }
  },
  {
    $sort: { count: -1 }
  },
  {
    $group: {
      _id: "$_id.species",
      max_region: { $first: "$_id.region" },
      observations_count: { $first: "$count" }
    }
  },
  {
    $project: {
      _id: 0,
      species: "$_id",
      region: "$max_region",
      count: "$observations_count"
    }
  }
]);








// 1. Средний уровень CO2 по странам, превышающий глобальный средний уровень
db.emissions.aggregate([
  { $group: { _id: "$country", avg_co2: { $avg: "$CO_2" } } },
  { $group: { _id: null, global_avg: { $avg: "$avg_co2" }, countries: { $push: "$$ROOT" } } },
  { $unwind: "$countries" },
  { $match: { $expr: { $gt: ["$countries.avg_co2", "$global_avg"] } } },
  { $project: { _id: 0, country: "$countries._id", average_emissions: "$countries.avg_co2", global_avg: 1 } }
]);

// 2. Количество наблюдений видов животных по регионам (топ-1 регион для каждого вида)
db.animals.aggregate([
  { $group: { _id: { species: "$species", region: "$region" }, count: { $sum: 1 } } },
  { $sort: { "_id.species": 1, count: -1 } },
  { $group: { _id: "$_id.species", top_region: { $first: "$_id.region" }, max_observations: { $first: "$count" } } }
]);

// 3. Города с превышением нормы загрязнения >= 10 раз за последний год (2025)
db.pollution.aggregate([
  { $match: { 
      year: { $gte: new Date("2025-01-01"), $lte: new Date("2025-12-31") },
      $expr: { $gt: ["$pollution_level", "$permissible_limit"] }
  } },
  { $group: { _id: "$city", violations_count: { $sum: 1 } } },
  { $match: { violations_count: { $gte: 10 } } }
]);

// 4. Топ-3 проекта по объему (площади) лесовосстановления в каждой стране
db.projects.aggregate([
  { $match: { project_type: 1 } }, 
  { $sort: { country: 1, volume: -1 } },
  { $group: { 
      _id: "$country", 
      top_projects: { $push: { name: "$name", volume: "$volume" } } 
  } },
  { $project: { top_projects: { $slice: ["$top_projects", 3] } } }
]);

// 5. Виды отходов, перерабатываемые более чем в 5 разных странах
db.waste.aggregate([
  { $group: { _id: "$waste_type", unique_countries: { $addToSet: "$country" } } },
  { $project: { waste_type: "$_id", country_count: { $size: "$unique_countries" } } },
  { $match: { country_count: { $gt: 5 } } }
]);

// 6. Среднее содержание металлов в водоеме в сравнении с глобальной медианой всех средних значений
db.water_quality.aggregate([
  { $group: { _id: "$reservoir", avg_heavy: { $avg: "$heavy_metal_content" } } },
  { $sort: { avg_heavy: 1 } },
  { $group: { _id: null, reservoirs: { $push: "$$ROOT" }, all_avg_values: { $push: "$avg_heavy" } } },
  { $addFields: { 
      median_value: { $arrayElemAt: ["$all_avg_values", { $floor: { $divide: [{ $size: "$all_avg_values" }, 2] } }] } 
  } },
  { $unwind: "$reservoirs" },
  { $project: { 
      _id: 0, 
      reservoir: "$reservoirs._id", 
      average: "$reservoirs.avg_heavy", 
      global_median: "$median_value" 
  } }
]);

// 7. Организации, участвующие более чем в 3 проектах одновременно (на текущий момент)
db.projects.aggregate([
  { $group: { 
      _id: "$organization", 
      project_count: { $sum: 1 }, 
      project_list: { $push: "$name" } 
  } },
  { $match: { project_count: { $gt: 3 } } }
]);

// 8. Распределение уровней загрязнения по категориям (Низкий, Средний, Высокий)
db.pollution.aggregate([
  { $bucket: {
      groupBy: "$pollution_level",
      boundaries: [0, 50000, 100000, Infinity],
      default: "Other",
      output: { count: { $sum: 1 }, cities: { $addToSet: "$city" } }
  } },
  { $addFields: { 
      category: { 
        $switch: {
          branches: [
            { case: { $eq: ["$_id", 0] }, then: "Низкий" },
            { case: { $eq: ["$_id", 50000] }, then: "Средний" },
            { case: { $eq: ["$_id", 100000] }, then: "Высокий" }
          ]
        }
      } 
  } }
]);

// 9. Виды животных с последовательным снижением численности 3 года подряд
db.animals.aggregate([
  { $sort: { species: 1, year: 1 } },
  { $group: { _id: "$species", pop_history: { $push: "$population" } } },
  { $match: { 
      $expr: {
        $anyElementTrue: {
          $map: {
            input: { $range: [0, { $subtract: [{ $size: "$pop_history" }, 2] }] },
            as: "i",
            in: { $and: [
              { $gt: [{ $arrayElemAt: ["$pop_history", "$$i"] }, { $arrayElemAt: ["$pop_history", { $add: ["$$i", 1] }] }] },
              { $gt: [{ $arrayElemAt: ["$pop_history", { $add: ["$$i", 1] }] }, { $arrayElemAt: ["$pop_history", { $add: ["$$i", 2] }] }] }
            ]}
          }
        }
      }
  } }
]);

// 10. Длительность проектов в днях и их рейтинг по длительности внутри каждой страны
db.projects.aggregate([
  { $addFields: { 
      duration_days: { 
        $round: [{ $divide: [{ $subtract: ["$end_date", "$beg_date"] }, 1000 * 60 * 60 * 24] }, 0] 
      } 
  } },
  { $setWindowFields: {
      partitionBy: "$country",
      sortBy: { duration_days: -1 },
      output: { rank_in_country: { $rank: {} } }
  } },
  { $project: { _id: 0, name: 1, country: 1, duration_days: 1, rank_in_country: 1 } }
]);
