import { plainToClass } from "class-transformer";

export class Mapper {
    static mapEntityToDto<Entity, Dto>(entity: Entity, dtoClass: new () => Dto): Dto {
      return plainToClass(dtoClass, entity);
    }
  }