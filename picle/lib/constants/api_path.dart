const serverEndpoint = 'www.picle.server.com';
final apiPath = {
  'getPreviews': (userId) => '/api/v1/routine/getPreviews/$userId',
  'getRoutines': (userId) => '/api/v1/routine/getByDate/$userId',
};
