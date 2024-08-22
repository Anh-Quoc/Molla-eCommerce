import {Column, Entity, JoinColumn, ManyToOne, PrimaryGeneratedColumn} from "typeorm";
import {User} from "../../users/entities/User.entity";

@Entity({name: 'products'})
export class Product{
    @PrimaryGeneratedColumn()
    id: number;

    @Column({name: 'url'})
    url: string;

    @Column({name: 'name'})
    name: string;

    @Column({name: 'description'})
    description: string;

    @Column({name: 'price'})
    price: number;

    @Column({name: 'stock'})
    stock: number;

    @Column({name: 'types', type: 'jsonb'})
    types: Record<string, any>[];

    @Column({name: 'tags', type: 'jsonb'})
    tags: string[];

    @Column({name: 'total_comments'})
    totalComments: number;

    @Column({name: 'total_ratings'})
    totalRatings: number;

    @Column({name: 'created_at'})
    createdAt: Date;

    @Column({name: 'updated_at'})
    updatedAt: Date;

    @ManyToOne(() => User)
    @JoinColumn({ name: 'created_by' })
    createdBy: User;

    @ManyToOne(() => User)
    @JoinColumn({ name: 'updated_by' })
    updatedBy: User;


}