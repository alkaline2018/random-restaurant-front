<template>
  <div>
    <button @click="fetchRestaurants">식당 추천받기</button>
    <div v-if="restaurants.length">
      <div v-for="restaurant in restaurants" :key="restaurant.id" class="restaurant-card">
        <h3>{{ restaurant.name }}</h3>
        <p>{{ restaurant.category }}</p>
        <button @click="findRoute(restaurant)">길찾기</button>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import proj4 from 'proj4';
import { register } from 'ol/proj/proj4';
import { transform } from 'ol/proj';

// EPSG:5181 좌표계 등록
proj4.defs(
  'EPSG:5181',
  '+proj=tmerc +lat_0=38 +lon_0=127 +k=1 +x_0=200000 +y_0=500000 +ellps=GRS80 +units=m +no_defs'
);
register(proj4); // OpenLayers에 등록

export default {
  props: {
    latitude: Number,
    longitude: Number,
    distance: {
      type: Number,
      default: 600, // 기본 반경 거리
    },
  }, // 부모 컴포넌트에서 받은 위도, 경도 값
  data() {
    return {
      restaurants: [], // 식당 목록
    };
  },
  watch: {
    latitude: 'fetchRecommendations',
    longitude: 'fetchRecommendations',
    distance: 'fetchRecommendations',
  },
  methods: {
    // 식당 데이터를 백엔드에서 가져오는 메서드
    async fetchRestaurants() {
      try {
        const response = await axios.get(`http://localhost:18080/restaurants`, {
          params: {
            latitude: this.latitude,
            longitude: this.longitude,
            distance: this.distance,
          },
        });
        this.restaurants = response.data; // 받아온 식당 데이터를 저장
      } catch (error) {
        console.error('식당 데이터를 가져오는 중 에러 발생:', error);
      }
    },
    // 네이버맵 도보 길찾기 URL 생성 및 열기
    findRoute(restaurant) {
      // 위경도 좌표를 TM 좌표로 변환
      const [startX, startY] = transform([this.longitude, this.latitude], 'EPSG:4326', 'EPSG:3857'); // 출발지 (내 위치)
      const [destX, destY] = transform([restaurant.x, restaurant.y], 'EPSG:4326', 'EPSG:3857'); // 목적지 (식당 위치)

      // 네이버맵 도보 길찾기 URL 생성
      const url = `https://map.naver.com/p/directions/${startX},${startY},내 위치,,SIMPLE_POI/${destX},${destY},${encodeURIComponent(restaurant.name)},,SIMPLE_POI/-/walk?c=15.00,0,0,0,dh`
      
      // 새 창에서 네이버맵 열기
      window.open(url);
    },
  },
};
</script>

<style scoped>
.restaurant-card {
  border: 1px solid #ccc;
  padding: 10px;
  margin: 10px;
}
</style>
