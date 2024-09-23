<template>
    <div>
        <div id="map" style="width: 100%; height: 500px"></div>
        <button @click="getCurrentLocation">내 위치로 설정</button>
        <p>선택된 위도: {{ latitude }}</p>
        <p>선택된 경도: {{ longitude }}</p>
    </div>
</template>

<script>
import "ol/ol.css"
import { Map, View, Feature } from "ol"
import TileLayer from "ol/layer/Tile"
import OSM from "ol/source/OSM"
import { fromLonLat, toLonLat } from "ol/proj"
import { defaults as defaultControls } from "ol/control"
import VectorSource from "ol/source/Vector"
import VectorLayer from "ol/layer/Vector"
import Point from "ol/geom/Point"
import { Icon, Style } from "ol/style"

export default {
    data() {
        return {
            map: null,
            latitude: 37.5221835, // 다나님 회사
            longitude: 126.92002, // 다나님 회사
            markerSource: new VectorSource(), // 마커 소스
        }
    },
    mounted() {
        this.initMap()
    },
    methods: {
        initMap() {
            // 지도 초기화
            this.map = new Map({
                target: "map",
                layers: [
                    new TileLayer({
                        source: new OSM(),
                    }),
                    new VectorLayer({
                        source: this.markerSource, // 마커 레이어 추가
                    }),
                ],
                view: new View({
                    center: fromLonLat([this.longitude, this.latitude]),
                    zoom: 17,
                }),
                controls: defaultControls(),
            })

            // 지도 클릭 시 이벤트 처리
            this.map.on("click", (event) => {
                const [lon, lat] = toLonLat(event.coordinate)
                this.longitude = lon
                this.latitude = lat
                this.addMarker(lon, lat)
                this.map.getView().setCenter(fromLonLat([lon, lat])) // 클릭한 위치로 지도 중심 이동
                this.$emit('locationSelected', { lon, lat }); // 선택된 좌표를 상위로 전달
            })            

            this.addMarker(this.longitude, this.latitude)
        },
        addMarker(lon, lat) {
            // 기존 마커 초기화
            this.markerSource.clear()

            // 새 마커 생성
            const marker = new Feature({
                geometry: new Point(fromLonLat([lon, lat])),
            })

            // 마커 스타일 설정 (여기서는 기본 아이콘을 사용)
            marker.setStyle(new Style({
                image: new Icon({
                    anchor: [0.5, 1],
                    src: "https://openlayers.org/en/latest/examples/data/icon.png", // 마커 이미지 (원하는 이미지를 사용할 수 있음)
                }),
            }))

            // 마커 소스에 추가
            this.markerSource.addFeature(marker)
        },
        getCurrentLocation() {
            // 사용자의 현재 위치로 지도 중심 이동
            navigator.geolocation.getCurrentPosition(
                (position) => {
                    const { latitude, longitude } = position.coords
                    this.latitude = latitude
                    this.longitude = longitude
                    this.map.getView().setCenter(fromLonLat([longitude, latitude]))
                    this.addMarker(longitude, latitude) // 현재 위치에 마커 추가
                },
                () => {
                    alert("위치 정보를 가져오지 못했습니다.")
                },
            )
        },
    },
}
</script>

<style>
#map {
    width: 100%;
    height: 500px;
}
</style>
