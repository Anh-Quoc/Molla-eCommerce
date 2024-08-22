import {ApiProperty} from "@nestjs/swagger";
import {Expose} from "class-transformer";

export class ProductResponseDto {
    @ApiProperty()
    @Expose()
    id: number;

    @ApiProperty()
    @Expose()
    url: string;

    @ApiProperty()
    @Expose()
    name: string;

    @ApiProperty()
    @Expose()
    description: string;

    @ApiProperty()
    @Expose()
    price: number;

    @ApiProperty()
    @Expose()
    stock: number;

    @ApiProperty()
    @Expose()
    types: Record<string, any>[];

    @ApiProperty()
    @Expose()
    tags: string[];

    @ApiProperty()
    @Expose()
    totalComments: number;

    @ApiProperty()
    @Expose()
    totalRatings: number;

}