import {Injectable} from '@nestjs/common';
import {InjectRepository} from "@nestjs/typeorm";
import {Product} from "./entities/product.entity";
import {Repository} from "typeorm";

@Injectable()
export class ProductsService {
    constructor(
        @InjectRepository(Product)
        private productRepository: Repository<Product>,
    ) {
    }

    async getListProducts(title: string, types: Record<string, any>[], tags: string[], page: number, pageSize: number): Promise<Product[]> {
        const queryBuilder = this.productRepository.createQueryBuilder('products');

        // Apply filters based on title
        if (title) {
            queryBuilder.andWhere('LOWER(products.name) LIKE :title', {title: `%${title.toLowerCase()}%`});
        }

        // Apply filters based on types
        if (types?.length) { //
            queryBuilder.andWhere('products.types @> :types', {types});
        }

        console.log('Tags: ', tags);

        if(Array.isArray(tags) && tags.length > 0){
            queryBuilder.andWhere('products.tags @> :tags::jsonb', {tags: JSON.stringify(tags)})
        }

        // Apply pagination
        queryBuilder.skip((page - 1) * pageSize).take(pageSize);

        // Execute query
        return await queryBuilder.getMany();
    }

}
