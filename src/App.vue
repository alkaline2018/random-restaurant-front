<template>
  <div id="app">
    <h1>랜덤 식당 추천</h1>
    <LocationMap @locationSelected="updateLocation" />
    <label for="distance">반경 거리(미터): </label>
    <input type="number" id="distance" v-model="distance" />
    <RestaurantRecommendations :latitude="latitude" :longitude="longitude" />
  </div>
</template>

<script>
import LocationMap from './components/LocationMap.vue';
import RestaurantRecommendations from './components/RestaurantRecommendations.vue';

export default {
  data() {
    return {
      latitude: 37.5221835,
      longitude: 126.92002,
      distance: 600, // 기본 반경 거리 설정
    };
  },
  components: {
    LocationMap,
    RestaurantRecommendations,
  },
  methods: {
    updateLocation({lat, lon}) {
      this.latitude = lat;
      this.longitude = lon;
    },
  },
};
</script>
