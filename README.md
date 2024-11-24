
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mlitdata

<!-- badges: start -->
<!-- badges: end -->

The goal of mlitdata is to …

## Credits

- In Japanese: **「このサービスは、国土交通データプラットフォームの API
  機能を使用していますが、最新のデータを保証するものではありません。」**
- In English: **“This service uses the API functionality of the MLIT
  Data Platform, but does not guarantee up-to-date data.”**

## Installation

You can install the development version of mlitdata like so:

``` r
# install.packages("devtools")
devtools::install_github("UchidaMizuki/mlitdata")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(mlitdata)

mlitdata_catalog()
```

<div class="kable-table">

| catalog_id   | catalog_title                                                |
|:-------------|:-------------------------------------------------------------|
| cals         | 電子納品保管管理システム                                     |
| ipf          | 社会資本情報                                                 |
| ngi          | 国土地盤情報データベース                                     |
| rsdb         | 全国道路施設点検データベース                                 |
| mcc          | 地方公共団体の工事データ（My City Construction）             |
| nlni_ksj     | 国土数値情報                                                 |
| mlit_plateau | 都市3Dデータ（PLATEAU）                                      |
| rtc          | 全国道路・街路交通情勢調査一般交通量調査（道路交通センサス） |
| hwq          | 水文水質データベース                                         |
| tcd          | 東京都ICT活用工事データ                                      |
| ffd          | FF-Data（訪日外国人流動データ）                              |
| alpc         | 静岡県航空レーザ点群                                         |
| gtfs         | GTFSデータリポジトリ                                         |
| dimaps       | 統合災害情報システム（DiMAPS）                               |
| lpfs         | 全国幹線旅客純流動調査                                       |
| msil         | 海洋状況表示システム（海しる）                               |
| sip4d        | SIP4D                                                        |
| dhb          | ダム便覧                                                     |
| sample       | サンプルデータ                                               |
| ndm          | 自然災害伝承碑                                               |
| nxc          | 高速道路会社の工事発注図面データ                             |
| crtc         | 工事実績情報（コリンズデータ）                               |

</div>

``` r
mlitdata_catalog("ipf",
                 dataset_fields = c("id", "title"))
```

<div class="kable-table">

| catalog_id | catalog_title | dataset_id                  | dataset_title   |
|:-----------|:--------------|:----------------------------|:----------------|
| ipf        | 社会資本情報  | ipf_airport                 | 空港            |
| ipf        | 社会資本情報  | ipf_government_building     | 官庁施設        |
| ipf        | 社会資本情報  | ipf_harbor_mooring_facility | 港湾 係留施設   |
| ipf        | 社会資本情報  | ipf_park                    | 公園            |
| ipf        | 社会資本情報  | ipf_river_dam               | 河川 ダム       |
| ipf        | 社会資本情報  | ipf_river_sand_barrier      | 河川 砂防       |
| ipf        | 社会資本情報  | ipf_river_sluice_gate       | 河川 樋門・樋管 |
| ipf        | 社会資本情報  | ipf_river_water_gate        | 河川 水門       |
| ipf        | 社会資本情報  | ipf_river_weir              | 河川 堰         |
| ipf        | 社会資本情報  | ipf_sewage_treatment_plant  | 下水道 処理場   |
| ipf        | 社会資本情報  | ipf_water_course_sign       | 航路標識        |

</div>
