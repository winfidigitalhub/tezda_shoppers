class Rating {
  final double rate;
  final int count;

  Rating({required this.rate, required this.count});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rate: json['rate'].toDouble(),
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rate': rate,
      'count': count,
    };
  }
}

class RatingReview {
  final String reviewerName;
  final String reviewText;
  final double rating;

  RatingReview({
    required this.reviewerName,
    required this.reviewText,
    required this.rating,
  });

  factory RatingReview.fromJson(Map<String, dynamic> json) {
    return RatingReview(
      reviewerName: json['reviewerName'],
      reviewText: json['reviewText'],
      rating: json['rating'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviewerName': reviewerName,
      'reviewText': reviewText,
      'rating': rating,
    };
  }
}

class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String image;
  final Rating rating;
  final List<String> availableSizes;
  final List<String> availableColors;
  final List<RatingReview> reviews;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.image,
    required this.rating,
    required this.availableSizes,
    required this.availableColors,
    required this.reviews,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Fetch reviews for this product id from the data array
    List<RatingReview> reviews = [];
    for (var product in data) {
      if (product['id'] == json['id']) {
        reviews = List<RatingReview>.from(
          (product['reviews'] as List<dynamic>).map(
                (review) => RatingReview.fromJson(review),
          ),
        );
        break;
      }
    }

    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      category: json['category'],
      image: json['image'],
      rating: Rating.fromJson(json['rating']),
      availableSizes: ['S', 'M', 'L', 'XL'],
      availableColors: ['Red', 'Yellow', 'White', 'Blue', 'Black', 'Orange', 'Green'],
      reviews: reviews,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'image': image,
      'rating': rating.toJson(),
      'availableSizes': availableSizes,
      'availableColors': availableColors,
      'reviews': reviews.map((review) => review.toJson()).toList(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': {
        'rate': rating.rate,
        'count': rating.count,
      },
      'reviews': reviews.map((review) => review.toJson()).toList(),
    };
  }


  Product toDetails() {
    return Product(
      id: id,
      title: title,
      description: description,
      price: price,
      category: category,
      image: image,
      rating: rating,
      availableSizes: availableSizes,
      availableColors: availableColors,
      reviews: reviews,
    );
  }
}

List<Map<String, dynamic>> data = [
  {
    "id": 1,
    "reviews": [
      {
        "reviewerName": "John Doe",
        "reviewText": "Great backpack, very durable. I've been using it for a few months now, and it has held up very well. The material is sturdy and the zippers are smooth. It also has plenty of space for all my belongings. Highly recommend!",
        "rating": 4.5
      },
      {
        "reviewerName": "Jane Smith",
        "reviewText": "Stylish and functional. The design is modern and the functionality is excellent. It fits my laptop perfectly and still has room for more. I love the color options as well.",
        "rating": 4.0
      },
      {
        "reviewerName": "Peter Parker",
        "reviewText": "Good value for money. The product is reasonably priced and delivers on its promises. The design is simple but effective, and it works well for my needs.",
        "rating": 4.2
      }
    ]
  },
  {
    "id": 2,
    "reviews": [
      {
        "reviewerName": "Alice Johnson",
        "reviewText": "Very comfortable and fits well. The material is soft and breathable, making it perfect for daily wear. I've received several compliments on the fit and style. Definitely a great buy!",
        "rating": 4.5
      },
      {
        "reviewerName": "Bob Brown",
        "reviewText": "Good quality material. I've washed it several times and it still looks brand new. The stitching is solid and the fabric doesn't shrink. Highly satisfied with this purchase.",
        "rating": 4.0
      },
      {
        "reviewerName": "David Black",
        "reviewText": "Not what I expected. The product is decent, but it didn't quite live up to my expectations. The material is good, but the fit wasn't as great as I hoped. It's still usable, but I probably wouldn't purchase it again.",
        "rating": 3.0
      }
    ]
  },
  {
    "id": 3,
    "reviews": [
      {
        "reviewerName": "Charlie White",
        "reviewText": "Exceeded my expectations. The product is well-made and the attention to detail is impressive. It's clear that a lot of thought went into the design and construction. Will definitely be buying more from this brand.",
        "rating": 5.0
      },
      {
        "reviewerName": "David Black",
        "reviewText": "Not what I expected. The product is decent, but it didn't quite live up to my expectations. The material is good, but the fit wasn't as great as I hoped. It's still usable, but I probably wouldn't purchase it again.",
        "rating": 3.0
      }
    ]
  },
  {
    "id": 4,
    "reviews": [
      {
        "reviewerName": "Eve Green",
        "reviewText": "Highly recommend this product. It's exactly what I was looking for. The quality is top-notch and it's very comfortable to use. I've already recommended it to several friends.",
        "rating": 4.8
      },
      {
        "reviewerName": "Frank Blue",
        "reviewText": "Worth every penny. This product is a great investment. It has made my life so much easier and more organized. The design is sleek and it performs exactly as described.",
        "rating": 4.5
      }
    ]
  },
  {
    "id": 5,
    "reviews": [
      {
        "reviewerName": "Grace Pink",
        "reviewText": "Decent quality for the price. It's not the best I've ever used, but for the price point, it's quite good. It gets the job done and looks pretty nice as well.",
        "rating": 3.5
      },
      {
        "reviewerName": "Hank Yellow",
        "reviewText": "Could be better. The product has potential, but there are a few areas where it falls short. The material could be more durable and the fit could be improved. It's okay, but not great.",
        "rating": 3.0
      }
    ]
  },
  {
    "id": 6,
    "reviews": [
      {
        "reviewerName": "John Doe",
        "reviewText": "Excellent product, very happy with it. The quality is fantastic and it performs just as expected. I use it daily and it has made a big difference. Definitely worth the purchase!",
        "rating": 4.7
      },
      {
        "reviewerName": "Jane Smith",
        "reviewText": "Good value for money. The product is reasonably priced and delivers on its promises. The design is simple but effective, and it works well for my needs.",
        "rating": 4.2
      }
    ]
  },
  {
    "id": 7,
    "reviews": [
      {
        "reviewerName": "Alice Johnson",
        "reviewText": "Highly durable and stylish. I've been using it for a while now and it still looks great. The durability is impressive and the style is timeless. Very satisfied with this purchase.",
        "rating": 4.6
      },
      {
        "reviewerName": "Bob Brown",
        "reviewText": "Comfortable and well-made. The product is very comfortable to use and the build quality is excellent. I've recommended it to friends and family because it's just that good.",
        "rating": 4.3
      }
    ]
  },
  {
    "id": 8,
    "reviews": [
      {
        "reviewerName": "Charlie White",
        "reviewText": "Exceeded my expectations. The product is well-made and the attention to detail is impressive. It's clear that a lot of thought went into the design and construction. Will definitely be buying more from this brand.",
        "rating": 5.0
      },
      {
        "reviewerName": "David Black",
        "reviewText": "Not what I expected. The product is decent, but it didn't quite live up to my expectations. The material is good, but the fit wasn't as great as I hoped. It's still usable, but I probably wouldn't purchase it again.",
        "rating": 3.0
      }
    ]
  },
  {
    "id": 9,
    "reviews": [
      {
        "reviewerName": "Eve Green",
        "reviewText": "Highly recommend this product. It's exactly what I was looking for. The quality is top-notch and it's very comfortable to use. I've already recommended it to several friends.",
        "rating": 4.8
      },
      {
        "reviewerName": "Frank Blue",
        "reviewText": "Worth every penny. This product is a great investment. It has made my life so much easier and more organized. The design is sleek and it performs exactly as described.",
        "rating": 4.5
      }
    ]
  },
  {
    "id": 10,
    "reviews": [
      {
        "reviewerName": "Grace Pink",
        "reviewText": "Decent quality for the price. It's not the best I've ever used, but for the price point, it's quite good. It gets the job done and looks pretty nice as well.",
        "rating": 3.5
      },
      {
        "reviewerName": "Hank Yellow",
        "reviewText": "Could be better. The product has potential, but there are a few areas where it falls short. The material could be more durable and the fit could be improved. It's okay, but not great.",
        "rating": 3.0
      }
    ]
  },
  {
    "id": 11,
    "reviews": [
      {
        "reviewerName": "John Doe",
        "reviewText": "Excellent product, very happy with it. The quality is fantastic and it performs just as expected. I use it daily and it has made a big difference. Definitely worth the purchase!",
        "rating": 4.7
      },
      {
        "reviewerName": "Jane Smith",
        "reviewText": "Good value for money. The product is reasonably priced and delivers on its promises. The design is simple but effective, and it works well for my needs.",
        "rating": 4.2
      }
    ]
  },
  {
    "id": 12,
    "reviews": [
      {
        "reviewerName": "Alice Johnson",
        "reviewText": "Highly durable and stylish. I've been using it for a while now and it still looks great. The durability is impressive and the style is timeless. Very satisfied with this purchase.",
        "rating": 4.6
      },
      {
        "reviewerName": "Bob Brown",
        "reviewText": "Comfortable and well-made. The product is very comfortable to use and the build quality is excellent. I've recommended it to friends and family because it's just that good.",
        "rating": 4.3
      }
    ]
  },
  {
    "id": 13,
    "reviews": [
      {
        "reviewerName": "Charlie White",
        "reviewText": "Exceeded my expectations. The product is well-made and the attention to detail is impressive. It's clear that a lot of thought went into the design and construction. Will definitely be buying more from this brand.",
        "rating": 5.0
      },
      {
        "reviewerName": "David Black",
        "reviewText": "Not what I expected. The product is decent, but it didn't quite live up to my expectations. The material is good, but the fit wasn't as great as I hoped. It's still usable, but I probably wouldn't purchase it again.",
        "rating": 3.0
      }
    ]
  },
  {
    "id": 14,
    "reviews": [
      {
        "reviewerName": "Eve Green",
        "reviewText": "Highly recommend this product. It's exactly what I was looking for. The quality is top-notch and it's very comfortable to use. I've already recommended it to several friends.",
        "rating": 4.8
      },
      {
        "reviewerName": "Frank Blue",
        "reviewText": "Worth every penny. This product is a great investment. It has made my life so much easier and more organized. The design is sleek and it performs exactly as described.",
        "rating": 4.5
      }
    ]
  },
  {
    "id": 15,
    "reviews": [
      {
        "reviewerName": "Grace Pink",
        "reviewText": "Decent quality for the price. It's not the best I've ever used, but for the price point, it's quite good. It gets the job done and looks pretty nice as well.",
        "rating": 3.5
      },
      {
        "reviewerName": "Hank Yellow",
        "reviewText": "Could be better. The product has potential, but there are a few areas where it falls short. The material could be more durable and the fit could be improved. It's okay, but not great.",
        "rating": 3.0
      }
    ]
  },
  {
    "id": 16,
    "reviews": [
      {
        "reviewerName": "John Doe",
        "reviewText": "Excellent product, very happy with it. The quality is fantastic and it performs just as expected. I use it daily and it has made a big difference. Definitely worth the purchase!",
        "rating": 4.7
      },
      {
        "reviewerName": "Jane Smith",
        "reviewText": "Good value for money. The product is reasonably priced and delivers on its promises. The design is simple but effective, and it works well for my needs.",
        "rating": 4.2
      }
    ]
  },
  {
    "id": 17,
    "reviews": [
      {
        "reviewerName": "Alice Johnson",
        "reviewText": "Highly durable and stylish. I've been using it for a while now and it still looks great. The durability is impressive and the style is timeless. Very satisfied with this purchase.",
        "rating": 4.6
      },
      {
        "reviewerName": "Bob Brown",
        "reviewText": "Comfortable and well-made. The product is very comfortable to use and the build quality is excellent. I've recommended it to friends and family because it's just that good.",
        "rating": 4.3
      }
    ]
  },
  {
    "id": 18,
    "reviews": [
      {
        "reviewerName": "Charlie White",
        "reviewText": "Exceeded my expectations. The product is well-made and the attention to detail is impressive. It's clear that a lot of thought went into the design and construction. Will definitely be buying more from this brand.",
        "rating": 5.0
      },
      {
        "reviewerName": "David Black",
        "reviewText": "Not what I expected. The product is decent, but it didn't quite live up to my expectations. The material is good, but the fit wasn't as great as I hoped. It's still usable, but I probably wouldn't purchase it again.",
        "rating": 3.0
      }
    ]
  },
  {
    "id": 19,
    "reviews": [
      {
        "reviewerName": "Eve Green",
        "reviewText": "Highly recommend this product. It's exactly what I was looking for. The quality is top-notch and it's very comfortable to use. I've already recommended it to several friends.",
        "rating": 4.8
      },
      {
        "reviewerName": "Frank Blue",
        "reviewText": "Worth every penny. This product is a great investment. It has made my life so much easier and more organized. The design is sleek and it performs exactly as described.",
        "rating": 4.5
      }
    ]
  },
  {
    "id": 20,
    "reviews": [
      {
        "reviewerName": "Grace Pink",
        "reviewText": "Decent quality for the price. It's not the best I've ever used, but for the price point, it's quite good. It gets the job done and looks pretty nice as well.",
        "rating": 3.5
      },
      {
        "reviewerName": "Hank Yellow",
        "reviewText": "Could be better. The product has potential, but there are a few areas where it falls short. The material could be more durable and the fit could be improved. It's okay, but not great.",
        "rating": 3.0
      }
    ]
  }
];

