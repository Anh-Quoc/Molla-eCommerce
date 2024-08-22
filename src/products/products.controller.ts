import {Controller, Get, Query} from '@nestjs/common';
import {ProductsService} from "./products.service";
import {ApiOperation, ApiQuery, ApiResponse} from "@nestjs/swagger";
import {Public} from "../auth/decorator/public.decorator";
import {ProductResponseDto} from "./dtos/product-response.dto";

@Controller('products')
export class ProductsController {

    constructor(
        private productsService: ProductsService
    ) {
    }

    @ApiOperation({ summary: 'Get a list of products' }) // Describes the operation
    @ApiQuery({ name: 'search', required: false, description: 'Search query for product names or descriptions' }) // Optional search query
    @ApiQuery({
        name: 'types',
        required: false,
        type: String,
        description: 'Filter types as a JSON string. Example: {"category": "laptop", "brand": "Apple"}',
    })
    @ApiQuery({
        name: 'tags',
        required: false,
        type: [String],
        description: 'List of tags to filter products',
        example: '["electronics", "smartphone"]'
    })
    @ApiQuery({ name: 'page', required: false, type: Number, description: 'Page number for pagination (default is 1)' }) // Optional page number
    @ApiQuery({ name: 'pageSize', required: false, type: Number, description: 'Number of items per page (default is 10)' }) // Optional page size
    @ApiResponse({ status: 200,
        description: 'Returns a list of products',
        example: [
            {
                "url": "macbook-pro-14",
                "name": "MacBook Pro 14",
                "description": "Apple MacBook Pro 14 with M2 chip, 16GB RAM, 512GB SSD.",
                "price": 1999.99,
                "stock": 10,
                "types": {
                    "category": "laptop",
                    "brand": "Apple"
                },
                "tags": [
                    "electronics",
                    "computers",
                    "apple"
                ],
                "totalComments": 25,
                "totalRatings": 100,
            },
            {
                "url": "iphone-14",
                "name": "iPhone 14",
                "description": "Apple iPhone 14 with A16 Bionic chip, 128GB storage.",
                "price": 899.99,
                "stock": 50,
                "details": {
                    "category": "smartphone",
                    "brand": "Apple"
                },
                "tags": [
                    "electronics",
                    "phones",
                    "apple"
                ],
                "totalComment": 100,
                "totalRating": 450,
            }
        ]
    })
    @ApiResponse({ status: 400, description: 'Invalid query parameters' }) // Bad request response
    @Public()
    @Get()
    getListProducts(
        @Query('search') title: string,
        @Query('types') types: Record<string, any>[],
        @Query('tags') tags: string[],
        @Query('page') page: number = 1, // Default page number to 1 if not provided
        @Query('pageSize') pageSize: number = 10, // Default page size to 10 if not provided
    ): Promise<ProductResponseDto[]> {
        return this.productsService.getListProducts(title, types, tags, page, pageSize);
    }

}
